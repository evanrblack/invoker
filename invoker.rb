#!/usr/bin/env ruby

require 'psych'
require 'hamlit'
require 'pdfkit'

class Invoice
  def initialize
    hash = Psych.load(File.read(ARGV[0] || 'invoice.yaml'), symbolize_names: true)
    hash.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def name
    if @paid
      "Invoice ##{@number} - Paid"
    else
      "Invoice ##{@number}"
    end
  end

  def render
    engine = Haml::Engine.new(File.read('invoice.haml'))
    engine.render(self)
  end
end

invoice = Invoice.new
PDFKit.new(invoice.render).to_file("#{invoice.name}.pdf")
puts "Created \"#{invoice.name}.pdf\""
