module TWG4
  CONFIG = {
      image_sizes: {
          thumbnail: {width: 170, height: 170},
          medium: {width: 620, height: 620}
      }
  }


  for (name, spec) in CONFIG[:image_sizes]
    CONFIG[:image_sizes][name].merge!(as_array: [spec[:width], spec[:height]])
  end

  CONFIG.freeze
end
