class AddUrlSegmentToAlbumsAndUsers < ActiveRecord::Migration[5.0]

  TABLES = [:albums, :users]

  def up
    TABLES.each do |table|
      add_column table, :url_segment, :string
      add_index table, :url_segment, unique: true
      fill_url_segment_column(table)
      change_column_null table, :url_segment, false
    end
  end

  def down
    TABLES.each do |table|
      remove_index table, :url_segment
      remove_column table, :url_segment
    end
  end


  def fill_url_segment_column(table)
    model = {albums: 'Album', users: 'User'}[table].constantize # This can raise NameError if model name change in future versions of this application
    say_with_time "#{model.name}.initialize_urls" do
      model.initialize_urls # This can raise exception if there is no 'initialize_urls' method on model (e.g. 'stringex' gem has been removed from Gemfile)
    end
  rescue Exception
    warn "WARNING! Unable to generate proper values for #{table}.url_segment column -- falling back to use #{table}.id column values. You might want to customize #{table}.url_segment column values manually."
    execute "UPDATE #{table} SET url_segment = id;"
  end

end
