# frozen_string_literal: true

shared_examples "a multiton" do
  let(:args) { [123, :symbol, "String"] }

  describe Multiton::Mixin do
    it "is an ancestor" do
      expect(subject.ancestors).to include(described_class)
    end
  end

  describe ".allocate" do
    it "is not accesible" do
      expect { subject.allocate }.to raise_error(NoMethodError)
    end
  end

  describe ".clone" do
    let(:clone) { subject.clone }

    context "when passing the same arguments" do
      it "generates a different instance than the original class" do
        expect(subject.instance(*args)).to be(subject.instance(*args))
        expect(clone.instance(*args)).to be(clone.instance(*args))
        expect(subject.instance(*args)).not_to be(clone.instance(*args))
      end
    end
  end

  describe ".dup" do
    let(:duplicate) { subject.dup }

    context "when passing the same arguments" do
      it "generates a different instance than the original class" do
        expect(subject.instance(*args)).to be(subject.instance(*args))
        expect(duplicate.instance(*args)).to be(duplicate.instance(*args))
        expect(subject.instance(*args)).not_to be(duplicate.instance(*args))
      end
    end
  end

  describe ".new" do
    it "is not accesible" do
      expect { subject.new }.to raise_error(NoMethodError)
    end
  end

  describe "instance" do
    let(:object) { subject.instance(*args) }
    let(:other_args) { [456, :other_symbol, "other string"] }
    let(:other_object) { subject.instance(*other_args) }

    context "when passing the same arguments" do
      it "generates the same instances" do
        expect(object).to be(subject.instance(*args))
        expect(other_object).to be(subject.instance(*other_args))
      end
    end

    context "when passing different arguments" do
      it "generates different instances" do
        expect(object).not_to be(other_object)
      end
    end

    describe "marshalling" do
      let(:marshalled_object) { Marshal.load(Marshal.dump(object)) }
      let(:other_marshalled_object) { Marshal.load(Marshal.dump(other_object)) }

      it "generates the same instances" do
        # We need to give the anonymous class a name so it can be marshalled.
        stub_const("Klass", subject)

        expect(object).to be(marshalled_object)
        expect(other_object).to be(other_marshalled_object)
        expect(marshalled_object).not_to be(other_marshalled_object)
      end
    end
  end

  describe "marshalling" do
    let(:marshalled_class) { Marshal.load(Marshal.dump(subject)) }

    context "when passing the same arguments" do
      it "generates the same instance than the original class" do
        # We need to give the anonymous class a name so it can be marshalled.
        stub_const("Klass", subject)

        expect(Klass.instance(*args)).to be(Klass.instance(*args))
        expect(marshalled_class.instance(*args)).to be(marshalled_class.instance(*args))
        expect(Klass.instance(*args)).to be(marshalled_class.instance(*args))
      end
    end
  end

  describe "subclass" do
    let(:subclass) { Class.new(subject) }

    context "when passing the same arguments" do
      it "generates a different instance than the original class" do
        expect(subject.instance(*args)).to be(subject.instance(*args))
        expect(subclass.instance(*args)).to be(subclass.instance(*args))
        expect(subject.instance(*args)).not_to be(subclass.instance(*args))
      end
    end
  end
end
