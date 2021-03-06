namespace :panopticon do
  desc "Register content with panopticon"
  task :register => :environment do
    require 'gds_api/panopticon'
    logger = GdsApi::Base.logger = Logger.new(STDERR).tap { |l| l.level = Logger::INFO }
    logger.info "Registering with panopticon..."

    edition_count = Edition.published.count
    # Pulling the editions into an array before iterating over them
    # This is more memory-hungry (to the tune of 100 megs or so) but it works
    # around the problem where re-registration takes so long that Mongo gives
    # up on the cursor it's holding and throws it away.
    Edition.published.to_a.each_with_index do |edition, index|
      begin
        logger.info "Registering #{edition.slug} [#{index}/#{edition_count}]"
        edition.register_with_panopticon
      rescue Mongoid::Errors::DocumentNotFound
        # This happens if an Edition doesn't have a corresponding Artefact
        logger.warn "Missing Artefact for #{edition.class.name} #{edition.slug}"
      end
    end
  end
end
