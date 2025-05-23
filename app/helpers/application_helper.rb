module ApplicationHelper
  def human_size(size)
    return "0 B" if size.nil? || size <= 0

    units = %w[B KB MB GB TB]
    index = 0

    while size >= 1024 && index < units.length - 1
      size /= 1024
      index += 1
    end

    "#{format('%.2f', size)} #{units[index]}"
  end
end
