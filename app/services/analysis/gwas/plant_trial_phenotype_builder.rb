class Analysis
  class Gwas
    class PlantTrialPhenotypeBuilder
      def call(plant_trial)
        documents = exporter(plant_trial).documents

        trait_descriptors = documents.fetch(:trait_descriptors)
        trait_id_idx = trait_descriptors.shift.index("Trait")
        trait_ids = trait_descriptors.map { |row| row[trait_id_idx] }

        trial_scoring = documents.fetch(:trial_scoring)
        sample_id_idx = trial_scoring.shift.index("Scoring unit name")
        sample_ids = trial_scoring.map { |row| row[sample_id_idx] }

        Result.new(trait_ids, sample_ids)
      end

      private

      def exporter(plant_trial)
        Submission::PlantTrialExporter.
          new(OpenStruct.new(submitted_object: plant_trial, user: plant_trial.user))
      end

      class Result
        attr_reader :trait_ids, :sample_ids

        def initialize(trait_ids, sample_ids)
          @trait_ids = trait_ids
          @sample_ids = sample_ids
        end

        def valid?; true; end
        def errors; []; end
      end
    end
  end
end
