require "representation/schema"

module Representation
  describe Schema do
    before(:each) do
      Representation.stub({ live: false })
    end

    it "parses nested schemas" do
      schema = {
        title: "person",
        type: Object,
        attributes: {
          contact: {
            type: Object,
            attributes: {
              name: { type: String },
              phone: { type: String }
            }
          }
        }
      }

      contact_name = "Home"
      contact_phone = "9675309"
      data = {
        extraneous_name: "Tommy Tutone",
        contact: {
          name: contact_name,
          phone: contact_phone,
          extraneous_details: "aka 'Jenny'"
        }
      }

      Schema.new(schema).pull(data).should == {
        person: {
          contact: {
            name: contact_name,
            phone: contact_phone
          }
        }
      }
    end

    it "parses nested arrays" do
      schema = {
        title: "people",
        type: Array,
        elements: {
          title: :person,
          type: Object,
          attributes: {
            name: { type: String },
            nicknames: {
              title: "nicknames",
              type: Array,
              elements: {
                title: :formalized_name,
                type: Object,
                attributes: {
                  name: { type: String },
                  age: { type: Integer }
                }
              }
            }
          }
        }
      }

      zissou = {
        name: "Steve Zissou",
        nicknames: [
          { name: "Stevezies", age: 2 },
          { name: "Papa Steve", age: 1 }
        ]
      }
      ned = {
        name: "Ned Plimpton",
        nicknames: [
          { name: "Kinsley", age: 4 }
        ]
      }
      people = [zissou, ned]

      Schema.new(schema).pull(people).should == {
        people: [{
            name: "Steve Zissou",
            nicknames: [
              { name: "Stevezies", age: 2 },
              { name: "Papa Steve", age: 1 }
            ]
          },
          {
            name: "Ned Plimpton",
            nicknames: [
              { name: "Kinsley", age: 4 }
            ]
          }
        ]
      }
    end
  end
end

