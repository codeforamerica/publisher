class Admin::PublicationsController < ApplicationController
  def show
    publication = Publication.where(panopticon_id: params[:id]).first
    publication = import_publication params[:id] unless publication.present?
    redirect_to '/admin/' + publication.class.name.tableize + '/' + publication.to_param
  end

  def import_publication panopticon_id
    Publication.import panopticon_id
  end
end
