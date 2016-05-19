require 'spec_helper'

describe MdmCSR do

  context 'creating certificate signin request' do
      
    before do
      params = {
                country: 'CL',
                state: 'RM',
                city: 'Santiago',
                department: 'Web',
                organization: 'Example Inc.',
                common_name: 'example.com',
                email: 'example@email.com'
              }

      @certificate = MdmCSR::Certificate.new(params)
    end

    it 'country should be CL' do
      expect(@certificate.country).to be == "CL"
    end

    it 'state should be RM' do
      expect(@certificate.state).to be == "RM"
    end

    it 'city should be Santiago' do
      expect(@certificate.city).to be == "Santiago"
    end

    it 'department should be Web' do
      expect(@certificate.department).to be == "Web"
    end

    it 'country should be Example Inc.' do
      expect(@certificate.organization).to be == "Example Inc."
    end

    it 'common_name should be example.com' do
      expect(@certificate.common_name).to be == "example.com"
    end

    it 'email should be example@email.com' do
      expect(@certificate.email).to be == "example@email.com"
    end

  end

end
