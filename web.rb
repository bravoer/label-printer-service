require 'prawn'
require 'prawn/measurement_extensions'

require_relative 'sparql_queries.rb'

OUTPUT_FILE = '/tmp/labels.pdf'
COLUMNS = 3
ROWS = 8

def label_name(contact)
  name = "#{contact['prefix']} #{contact['firstName']} #{contact['lastName']}".strip
  if contact['organizationName']
    name = "\nt.a.v. #{name}" if not name.empty?
    name = "#{contact['organizationName']}#{name}".strip
  end
  name
end

def label_address(contact)
  "#{contact['street']} #{contact['poBox']}\n#{contact['postCode']} #{contact['city']}".strip
end

get '/invitations' do
  contacts = select_contacts()
  
  Prawn::Document.generate(OUTPUT_FILE, :page_size => 'A4', :margin => [0, 0, 0, 0]) do
    font('Helvetica', :size => 10)
    
    # local variables
    columns = COLUMNS
    rows = ROWS
    labels_per_page = columns * rows

    contacts.size.times do |i|
      # page and grid organization
      page = i / labels_per_page
      position = i % labels_per_page
      contact = contacts[i]
      
      if position == 0
        start_new_page if page != 0
        define_grid(:columns => columns, :rows => rows, :gutter => 0)
      end
      
      # fill boxes with text
      box = grid(position / columns, position % columns)
      box.bounding_box do
        formatted_text_box [
          {:text => label_name(contact), :styles => [:bold]},
          {:text => "\n#{label_address(contact)}"},
        ], :at => [1.cm, box.height - 1.cm], :overflow => :shrink_to_fit        
      end
      
    end
  end
    
  send_file OUTPUT_FILE, :type => 'application/pdf'
end

###
# Helpers
###

helpers LabelPrinterService::SparqlQueries
