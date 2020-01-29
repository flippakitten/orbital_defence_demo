# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nasa::FirmsImport, type: :service do

  describe ".all" do
    context 'when request successful' do
      let(:vcr_time) { "2020-01-22 07:56:44 +0000".to_time }

      it 'creates fires', :vcr do
        Timecop.freeze(vcr_time) do
          expect{ Nasa::FirmsImport.all }.to change{ Fire.count }.by(3)
        end
      end
    end

    #context 'when request fails', :vcr do
    #  it 'logs an error' do
    #    expect(Rails.logger).to receive(:info).with('Nasa::FirmsImport#all - Failed to fetch')
    #
    #    Nasa::FirmsImport.all
    #  end
    #end
  end
end
