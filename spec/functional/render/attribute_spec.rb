module Render
  describe Attribute do
    context "generators" do
      before(:each) do
        @original_generators = Render.generators.dup
        Render.stub({ live: false })
      end

      after(:each) do
        Render.generators = @original_generators
      end

      it "uses matching generator for #faux_value" do
        name = "Canada Dry"
        Generator.new(String, %r{.*name.*}, proc { name })

        HashAttribute.new({ name: { type: String } }).default_value.should == name
      end

      it "uses bare-boned type if no generator is found" do
        bare_boned_string = "the_attribute_name (generated)"
        HashAttribute.new({ the_attribute_name: { type: String } }).default_value.should == bare_boned_string
      end
    end
  end
end