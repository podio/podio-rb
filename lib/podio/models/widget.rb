class Podio::Widget < ActivePodio::Base
  TYPE_TO_CONFIG = {'link' => 'links', 'text' => 'text'}

  property :widget_id, :integer
  property :ref_type, :string
  property :ref_id, :integer
  property :type, :string
  property :title, :string
  property :config, :string

  def initialize(attributes = {})
    super

    # has to run after the type is set
    self.raw_data = attributes['raw_data'] if attributes['raw_data']
  end

  def create
    self.widget_id = Widget.create(ref_type, ref_id, {:type => type, :title => title, :config => config})
  end

  def save
    Widget.update(id, {:title => title, :config => config})
  end

  def update_attributes(attributes)
    attributes.each do |key, value|
      self.send("#{key}=".to_sym, value)
    end
  end

  def raw_data
    return nil if config.nil?
    config[TYPE_TO_CONFIG[type]]
  end

  def raw_data=(data)
    self.config = normalized_hash_for_type(data)
  end

  def id
    widget_id
  end

private

  def normalized_hash_for_type(data)
    if type == 'image'
      data['file_id'] = data['file_id'].to_i if data['file_id']
      data['url'] = normalize_url(data['url'])
      data
    elsif type == 'link'
      data.each { |link| link['url'] = normalize_url(link['url']) }
      {TYPE_TO_CONFIG[type] => data}
    else
      {TYPE_TO_CONFIG[type] => data}
    end
  end

  def normalize_url(url)
    return nil if url.blank?
    return "http://#{url}" if !url.start_with?('http')
    url
  end
end
