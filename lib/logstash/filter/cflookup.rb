# encoding: utf-8
require 'logstash/filters/base'
require 'logstash/namespace'
require 'pg'

# The filter allows you to lookup a CF App Nname based on GUID

class LogStash::Filters::CFLookup < LogStash::Filters::Base
  config_name 'cflookup'
  milestone 1

  # Example:
  #
  #     filter {
  #       cflookup {
  #     host => '10.0.0.113'
  #     port => 5524
  #     user => 'ccadmin'
  #     password => 'supersecret'
  #       }
  #     }
  #

  config :host, :validate => :string, :required => true
  config :port, :validate => :number, :required => true
  config :user, :validate => :string, :required => true
  config :password, :validate => :string, :required => true

  public
  def register
    #Keep map of GUIDs to Apps
    @lookup = Hash.new

    #Lookup initial set of GUID to app mappings
    @conn = PGconn.connect(:hostaddr=>@host, :port=>@port, :dbname=>'ccdb', :user=>@user, :password=>@password)
    begin
      res = @conn.exec('select apps.guid,apps.name as a_name,organizations.name as o_name,spaces.name as s_name from apps,spaces,organizations where apps.space_id = spaces.id and spaces.organization_id=organizations.id;')
      print 'executed query!!'
      res.each do |row|
        #nameStr = row["a_name"] + "::" + row["o_name"] + "::" + row["s_name"]
        #@lookup[row["guid"] = nameStR
        #print "register --> Loaded app: " + @lookup[row["guid"]]
      end
    rescue Exception => e
      print e.message
      print e.backtrace.inspect
    ensure

    end

  end # def register

  def lookup(guid)
    #Lookup based on GUID
    begin
      res = @conn.exec('select apps.guid,apps.name as a_name,organizations.name as o_name,spaces.name as s_name from apps,spaces,organizations where apps.space_id = spaces.id and spaces.organization_id=organizations.id and apps.guid=\'' + guid + '\';')
      res.each do |row|

      end
    rescue Exception => e
      print e.message
      print e.backtrace.inspect
    ensure

    end

  end # def lookup

  public
  def filter(event)
    return unless filter?(event)

    #Lookup from our map

    #Exists add name

    #Else lookup, add to table, and add name

  end # def filter
end # class LogStash::Filters::CFLookup
