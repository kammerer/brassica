require 'rails_helper'

RSpec.describe Submission::Content do

  let(:submission) { Submission.new(content: { step01: { name: 'Bar' } }) }
  let(:content) { described_class.new(submission) }

  it "allows to access submission's step contents" do
    expect(content.step01.name).to eq 'Bar'
    expect(content[:step01].name).to eq 'Bar'
  end

  it "returns empty struct for each blank step" do
    expect(content.step02).to eq(OpenStruct.new)
    expect(content.step03).to eq(OpenStruct.new)
    expect(content.step04).to eq(OpenStruct.new)
  end

  context "#update" do
    it "updates submission" do
      content.update(:step02, plant_line: 'Baz')
      expect(submission.content.step02.plant_line).to eq 'Baz'
    end

    it "raises with invalid step" do
      expect { content.update(:step_fiz, {}) }.to raise_error(Submission::InvalidStep, "No step step_fiz")
    end
  end
end
