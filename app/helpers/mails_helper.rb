# frozen_string_literal: true

# Mail's helpers
module MailsHelper
  # Sample method to understand library working
  def static_map_url_sample
    # Default params: [size]='400x400', [center]='47.496047, 19.040801'
    map = QjobGoogle::MapsStatic::Map.new

    markers = [
      QjobGoogle::Models::Marker.new(styles: { label: 'A' }),
      QjobGoogle::Models::Marker.new(lat: '47.516770', lng: '19.068279', styles: { label: 'B' }),
      QjobGoogle::Models::Marker.new(lat: '47.520992', lng: '19.017480', styles: { label: 'C', color: 'green' })
    ]

    map.add_markers(markers)

    map.image_with_path
  end

  def map_for_task(task)
    map = QjobGoogle::MapsStatic::Map.new
    markers = []

    task.address_data.each do |address|
      markers.push QjobGoogle::Models::Marker.new(lat: address['geometry']['location']['lat'],
                                                  lng: address['geometry']['location']['lng'])
    end

    map.add_markers markers

    markers.length > 1 ? map.image_with_path : map.image
  end
end
