require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!


describe "shopping by themes", type: :feature do

  let(:themes_taxon) { FactoryGirl.create(:taxon, name: 'Themes')}
  let!(:theme1) { FactoryGirl.create(:taxon, name: 'Theme 1', taxonomy_id: themes_taxon.taxonomy_id, parent_id: themes_taxon.id ) }
  let!(:theme2) { FactoryGirl.create(:taxon, name: 'Theme 2', taxonomy_id: themes_taxon.taxonomy_id, parent_id: themes_taxon.id ) }

  let(:sets_taxon) { FactoryGirl.create(:taxon, name: 'Sets')}
  let!(:set10) { FactoryGirl.create(:taxon, name: 'Set 10', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id, theme_taxon_id: theme1.id ) }
  let!(:set11) { FactoryGirl.create(:taxon, name: 'Set 11', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id, theme_taxon_id: theme1.id ) }
  let!(:set20) { FactoryGirl.create(:taxon, name: 'Set 20', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id, theme_taxon_id: theme2.id ) }
  let!(:set21) { FactoryGirl.create(:taxon, name: 'Set 21', is_package_node: true, taxonomy_id: sets_taxon.taxonomy_id, parent_id: sets_taxon.id, theme_taxon_id: theme2.id ) }


  it "should show all themes when clicing the Explore Themed Collections link" do
    visit "/t/themes"
    expect(page).to have_content ("Theme 1")
    expect(page).to have_content ("Theme 2")
  end

  it "should not show and sets on a theme page" do
    visit "/t/themes"
    click_link 'taxon-link-themes/theme-1'
    expect(page).to_not have_link ('taxon-link-sets/set-10')
    expect(page).to_not have_link ('taxon-link-sets/set-11')
    expect(page).to_not have_link ('taxon-link-sets/set-20')
    expect(page).to_not have_link ('taxon-link-sets/set-21')
  end



end

