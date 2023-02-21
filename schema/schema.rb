#?
#? Usage:
#?    bash db/schema.sh <COMMAND> <VERSION> [PATCH]
#?
#? Commands:
#?    help      Show this message.
#?    apply     Load and run schema version applying patches.
#?    revert    Load and run schema version reverting patches.
#?

require "application"

include Application

@command = ARGV.at(0)
@version = ARGV.at(1)
@database = Database.connection

DATABASE_PATH = File.dirname(__FILE__)
SCHEMA_PATH = "#{DATABASE_PATH}/schema"
SCHEMA_VERSION_PATH="#{SCHEMA_PATH}/v#{@version}"

def usage
  File.open(__FILE__).grep(/^#\?/) do |line|
    puts line =~ /(^#\?.)().*/ && $2
  end
end

def schema_create_version_table
  @database.create_table? :schema_version do
    varchar :version, size: 16, null: false
    integer :patch, null: false, unique: [:version, :patch]
    timestamp :creation_date, null: false
  end
end

def schema_apply_patch(operation, file)
  File.read(file).scan %r{^-- [#{operation}]{3,}(.*)-- [#{operation}]{3,}$}m do |(statement)|
    @database.run statement
  end
end

def schema_patched?(patch)
  @database[:schema_version].where(version: @version, patch: patch).count >= 1
end

def schema_unpatched?(patch)
  !schema_patched? patch
end

def schema_insert_version(patch)
  @database[:schema_version].insert(version: @version, patch: patch, creation_date: Time.now) == 0
end

def schema_delete_version(patch)
  @database[:schema_version].where(version: @version, patch: patch).delete >= 1
end

def schema_version(patch, operation = "+")
  last_patch = File.basename(Dir["#{SCHEMA_VERSION_PATH}/*.sql"].sort.last).byteslice(0, 3)
  patches = (patch || last_patch).to_i.times.entries
  patches = patches.reverse if operation == "-"

  patches.each do |i|
    patch = i + 1
    file = Dir[format("#{SCHEMA_VERSION_PATH}/%03d*.sql", patch)].last

    printf "[%3s] v#{@version}.%03d %-63s", operation*3, patch, File.basename(file)

    if File.exists? file
      status = :skipped

      if operation == "+" and schema_unpatched? patch
        status = (schema_apply_patch(operation, file) && schema_insert_version(patch)) ? :done : :fail
      else
        status = :tilt
      end
      
      if operation == "-" and schema_patched? patch
        status = (schema_apply_patch(operation, file) && schema_delete_version(patch)) ? :done : :fail
      else
        status = :duck
      end

      puts status
    else
      puts "not found"
    end
  end
end

@cli = {
  apply:  lambda { |patch| schema_version patch, "+" },
  revert: lambda { |patch| schema_version patch, "-" },
  help:   lambda { |none| usage }
}

schema_create_version_table

ARGV.size == 0 && usage && exit(0)

@cli[@command.to_sym].call(ARGV.at(2))
