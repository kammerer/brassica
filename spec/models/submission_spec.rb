require 'rails_helper'

RSpec.describe Submission do

  describe '#content' do
    before {
      subject.content = {
        :step01 => { :foo => 1, :bar => "ble" },
        :step02 => { :baz => [1, 2, 3], :blah => {} }
      }
    }

    it 'allows to access step content' do
      expect(subject.content.step01.foo).to eq 1
      expect(subject.content.step01.bar).to eq "ble"
      expect(subject.content.step02.baz).to eq [1, 2, 3]
      expect(subject.content.step02.blah).to eq({})
    end
  end

  describe '#step' do
    it 'is set to default value when saving new record' do
      submission = build(:submission, step: nil)
      submission.save!
      expect(submission.step).to eq 'step01'
    end
  end

  describe '#step_forward' do
    let(:submission) { create(:submission) }

    it 'moves one step forward' do
      expect { submission.step_forward }.to change { submission.step }.from('step01').to('step02')
    end

    it 'raises if at last step' do
      submission.update_attribute(:step, submission.steps.last)
      expect { submission.step_forward }.to raise_error(Submission::CantStepForward)
    end
  end

  describe '#step_back' do
    let(:submission) { create(:submission) }

    it 'moves one step back' do
      submission.update_attribute(:step, submission.steps.last)
      expect { submission.step_back }.to change { submission.step }.from('step04').to('step03')
    end

    it 'raises if at first step' do
      expect { submission.step_back }.to raise_error(Submission::CantStepBack)
    end
  end

  describe '#finalize' do
    let(:submission) { create(:submission, finalized: false) }

    it 'updated submission' do
      submission.update_attribute(:step, submission.steps.last)
      expect { submission.finalize }.to change { submission.finalized? }.from(false).to(true)
    end

    it 'raises if not at last step' do
      expect { submission.finalize }.to raise_error(Submission::CantFinalize)
    end
  end

end