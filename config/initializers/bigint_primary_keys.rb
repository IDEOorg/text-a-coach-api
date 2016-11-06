# This file increases the datatype of our primary keys to be 64-bit increasing the maximum ID value from 2147483647 to 9223372036854775807.
# While we could end up with 2 billion raw computational records after a few years, we probably won't end up with 9 quintillion

require 'active_record/connection_adapters/postgresql_adapter'
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:primary_key] = 'bigserial primary key'
