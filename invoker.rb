require 'psych'
require 'hamlit'
require 'pdfkit'

class Invoice
  def initialize
    hash = Psych.load(File.read('invoice.yaml'), symbolize_names: true)
    hash.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def render
    engine = Haml::Engine.new(File.read('invoice.haml'))
    engine.render(self)
  end
end

invoice = Invoice.new
puts PDFKit.new(invoice.render).to_file('invoice.pdf')
