class ImagesController < ApplicationController
  caches_action :get, :expires_in => 30.days,
                :cache_path => proc { |c|
                  c.response.headers["Content-Disposition"] = "attachment; filename=#{params[:pid]}.png" if (params[:disposition] && params[:disposition] == 'download')
                  #Uncomment the line below to force a single content type for all images
                  #c.response.headers["Content-Type"] = 'image/png'
                  c.params
                }
  SIZES = {'thumb'=>'thumbnail', 'medium'=>'web850','large'=>'web1500'}
  EXT = {'image/png'=>'png', 'image/jpeg'=>'jpg', 'image/gif'=>'gif', 'image/tif' => 'tif'}
  def get
    rsrc = GenericResource.find(params[:pid])
    dsid = SIZES[params[:size]]
    ds = rsrc.datastreams[dsid]
    ext = EXT[ds.mimeType]
    filename = rsrc.pid.gsub(/\:/,'_') + '.' + dsid + '.' + ext
    response.headers.delete "Cache-Control"
    response.headers["Content-Disposition"] = "attachment; filename=#{params[:pid]}.png" if (params[:disposition] && params[:disposition] == 'download')
    response.headers['Content-Type'] = ds.mimeType
    ds.stream(self)
  end
end
