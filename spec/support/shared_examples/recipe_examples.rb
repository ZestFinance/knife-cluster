shared_examples_for 'recipe that deploys a rails app' do

  describe "HelperFunctions#create_shared_folders_for" do

    it "creates shared directories with right ownership and mode" do
      %w{config log pids cached-copy bundle system}.each do |dir|
        app = chef_run.node['rails'][appname]
        path_to_dir = "#{app['app_root']}/shared/#{dir}"
        created_dir = chef_run.directory(path_to_dir)

        chef_run.should create_directory(path_to_dir)
        created_dir.should be_owned_by app['deploy_user'], app['deploy_user']
        created_dir.should have_mode '0755'
        created_dir.should be_with_recursive_option
      end
    end
  end
end
