require 'yaml'

class Ziptz
  VERSION = '2.1.14'.freeze

  TZ_INFO = [
    {name: 'APO/FPO (time zone unknown)', offset: 0},
    {name: 'America/Puerto_Rico', offset: -4},
    {name: 'America/New_York', offset: -5},
    {name: 'America/Chicago', offset: -6},
    {name: 'America/Denver', offset: -7},
    {name: 'America/Los_Angeles', offset: -8},
    {name: 'America/Anchorage', offset: -9},
    {name: 'Pacific/Honolulu', offset: -10},
    {name: 'Pacific/Pago_Pago', offset: -11},
    {name: 'Pacific/Majuro', offset: 12},
    {name: 'Pacific/Guam', offset: 10},
    {name: 'Pacific/Palau', offset: 9},
    {name: 'Pacific/Pohnpei', offset: 11},
    {name: 'America/Phoenix', offset: -7},
    {name: 'America/Adak', offset: -10}
  ].freeze

  def time_zone_name(zip)
    get_time_zone(zip)
  end

  def time_zone_offset(zip)
    tz = time_zone_info(zip)
    tz && tz[:offset]
  end

  def time_zone_uses_dst?(zip)
    dst[zip.to_s.slice(0, 5)]
  end

  def zips(tz_name)
    zips_by_code(tz_name)
  end

  def inspect
    "#<#{self.class}:#{object_id}>"
  end

  protected

  def tz
    @tz ||= load_tz_data
  end

  def dst
    @dst ||= load_dst_data
  end

  def zips_by_code(tz_code)
    tz.select { |_, v| v.match(/#{tz_code}/i) }.keys.sort
  end

  def time_zone_info(zip)
    TZ_INFO.detect { |v| v[:name] == get_time_zone(zip) }
  end

  def get_time_zone(zip)
    tz[zip.to_s.slice(0, 5)]
  end

  def tz_data_path
    File.join(File.dirname(__FILE__), '..', 'data', 'tz.data')
  end

  def load_tz_data
    File.foreach(tz_data_path).with_object({}) do |line, data|
      zip, tz = line.strip.split('=')
      data[zip] = tz
    end
  end

  def dst_data_path
    File.join(File.dirname(__FILE__), '..', 'data', 'dst.data')
  end

  def load_dst_data
    File.foreach(dst_data_path).with_object({}) do |line, data|
      zip, dst = line.strip.split('=')
      data[zip] = dst == '1'
    end
  end
end
