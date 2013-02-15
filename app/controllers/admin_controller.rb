require 'hrwa/admin/solr_task_handler.rb'

# This controller handles administrative stuff
class AdminController < ApplicationController

  include Hrwa::MailHelper

  before_filter :do_authentication_check, :_check_for_allowed_users, :except => :login_options

  # THe do_authentication_check method below takes the place of devise's authenticate_service_user! and authenticate_user! methods.
  def do_authentication_check
    if !user_signed_in? && !service_user_signed_in?
      redirect_to :action => 'login_options'
    end
  end

  def login_options

  end

  def _check_for_allowed_users

    if service_user_signed_in?
      # That's fine
    elsif user_signed_in?
      # Need to check to see if this user is allowed to do anything
      allowed_users = ['elo2112', 'er2576', 'ba2213']
      if( ! allowed_users.include?(current_user.login) )
        # If not on the allowed list, then log this user out
        redirect_to destroy_user_session_path
      end
    end

  end

  def index
    _check_to_see_if_core_switching_is_possible

    #asf, fsf, site_detail, asf-hrwa-278
    @current_solr_urls =  {
                            'asf_url' => Hrwa::ArchiveSearchConfigurator.solr_url,
                            'fsf_url' => Hrwa::FindSiteSearchConfigurator.solr_url,
                            'site_detail_url' => Hrwa::SiteDetailConfigurator.solr_url,
                            'asf-hrwa-278_url' => Hrwa::ArchiveSearchWithStemmingAdjusterConfigurator.solr_url
                          }
  end

  def _check_to_see_if_core_switching_is_possible

    # Dev note: Solr server swithch functionality relies on config.cache_classes = true because we're storing the server info in class variables.
    # For more info on class caching, see:
    # http://stackoverflow.com/questions/2919988/rails-what-is-cached-when-using-config-cache-classes-true
    # or
    # http://stackoverflow.com/questions/2879891/config-cache-classes-true-in-production-mode-has-problems-in-ie

    # Core switching is possible if cache_classes is ON and none of the configurators are set to be unloadable
    @core_switching_is_possible = Rails.application.config.cache_classes || ActiveSupport::Dependencies.explicitly_unloadable_constants.select { |item| item =~ /\A Hrwa::.*Configurator \Z/x }.empty?

    if(@core_switching_is_possible)
      @core_switching_message = 'Good news!  Solr server overriding is available.'
    else
      @core_switching_message = 'Warning! Solr server switching will not work!<br /><br />'.html_safe +
                                                    "Rails.application.config.cache_classes = #{Rails.application.config.cache_classes}<br /><br />".html_safe +
                                                    "ActiveSupport::Dependencies.explicitly_unloadable_constants =<br />#{ActiveSupport::Dependencies.explicitly_unloadable_constants.to_s}".html_safe +
                                                    "<br /><br />Whenever config.cache_classes is false AND one or more of the configurators are unloadable, you cannot change Solr servers because any source code change will clear out the configurator class variables that store their currently associated Solr servers.".html_safe
    end
  end

  def manual_solr_server_override

    flash[:notice] = 'Invalid override request.' # Default response

    # The check below makes sure that only valid servers in the valid overrides section of solr.yml can be selected
    valid_overrides = ['test', 'carter', 'coolidge', 'harding', 'spatha', 'vorpal']
    solr_server_name = (valid_overrides.include?(params[:solr_server_name])) ? params[:solr_server_name] : nil

    if((params[:override] && ! solr_server_name.nil?) || params[:reset])

      _check_to_see_if_core_switching_is_possible

      if( @core_switching_is_possible )

        if(params[:reset])
          # The line below makes sure that only servers in the valid overrides section of solr.yml can be selected
          Hrwa::Configurator.reset_solr_config
          flash[:notice] = 'Your solr servers have been reset to their default settings.'.html_safe;
        end

        if(params[:override])
          solr_yml = YAML.load_file('config/solr.yml')[solr_server_name + '_solr']
          Hrwa::Configurator.override_solr_url(solr_yml)
          flash[:notice] = 'Your solr server settings have been changed.'.html_safe;
        end

      end

    end

    redirect_to admin_path
  end

  # This method updates the hardcoded browse list files using live data from the Solr index
  def update_hardcoded_browse_lists()
    solrTaskHandler = Hrwa::Admin::SolrTaskHandler.new
    result = solrTaskHandler.update_hardcoded_browse_lists

    if (result)
      flash[:notice] = 'Your browse lists have been updated.'
    else
      flash[:error] = "An error occurred and your browse lists could not be updated. Please check your log output for details."
    end

    redirect_to admin_path
  end

end
