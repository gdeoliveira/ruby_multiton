# frozen_string_literal: true

shared_examples "a multiton" do
  let(:args) { [123, :symbol, "String"] }

  def expect_classes_to_be_multitons(*klasses)
    expect(klasses).to all(be_a(Multiton))
    klasses.each {|klass| expect(klass.instance(*args)).to be(klass.instance(*args)) }
  end

  def expect_generated_instances_to_be_the_same(klass_1, klass_2)
    expect_classes_to_be_multitons(klass_1, klass_2)
    expect(klass_1.instance(*args)).to be(klass_2.instance(*args))
  end

  def expect_generated_instances_to_be_different(klass_1, klass_2)
    expect_classes_to_be_multitons(klass_1, klass_2)
    expect(klass_1.instance(*args)).not_to be(klass_2.instance(*args))
  end

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
        expect_generated_instances_to_be_different(subject, clone)
      end
    end
  end

  describe ".dup" do
    let(:duplicate) { subject.dup }

    context "when passing the same arguments" do
      it "generates a different instance than the original class" do
        expect_generated_instances_to_be_different(subject, duplicate)
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
        expect_generated_instances_to_be_the_same(Klass, marshalled_class)
      end
    end
  end

  describe "subclass" do
    let(:subclass) { Class.new(subject) }

    context "when passing the same arguments" do
      it "generates a different instance than the original class" do
        expect_generated_instances_to_be_different(subject, subclass)
      end
    end
  end
end
