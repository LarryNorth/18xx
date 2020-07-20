# frozen_string_literal: true

require_relative 'base'
require_relative 'tracker'

module Engine
  module Step
    class CompanyTrack < Base
      include Tracker

      ACTIONS = %w[lay_tile].freeze

      def actions(entity)
        return [] unless ability(entity)

        ACTIONS
      end

      def blocks?
        false
      end

      def process_lay_tile(action)
        lay_tile(action)
        ability(action.entity).use!
      end

      def available_hex(hex)
        @game.graph.connected_hexes(current_entity)[hex]
      end

      def ability(entity)
        return unless entity.company?

        ability = entity.abilities(:tile_lay, 'sold') if entity == @round.just_sold_company
        ability || entity.abilities(:tile_lay, 'track')
      end
    end
  end
end
