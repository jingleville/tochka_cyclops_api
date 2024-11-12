files = Dir["./schemas/requests/*"]

def constantize_file(name)
  name = name.gsub('.rb','').gsub('./','')
  'TochkaCyclopsApi::' + name.split('/').map { |el| el.split('_').map(&:capitalize).join }.join('::')
end

files.each do |file|
  require_relative file

  schema = self.class.const_get(constantize_file file)
  validation = schema.new.call(eval schema.const_get('EXAMPLE'))
  errors = validation.errors.to_h

  if errors.any?
    puts file, errors
  end
end
