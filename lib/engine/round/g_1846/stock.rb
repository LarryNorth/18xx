# frozen_string_literal: true

require_relative '../stock'

module Engine
  module Round
    module G1846
      class Stock < Stock
        def sellable_bundles(player, corporation)
          return [] if corporation.owner == @game.share_pool

          super(player, corporation)
        end

        def buy_shares(entity, bundle)
          bundle = bundle&.to_bundle

          if bundle_is_presidents_share_alone_in_pool?(bundle)
            percent = 10
            bundle = ShareBundle.new(bundle.shares, percent)
          end

          super(entity, bundle)
        end

        def can_buy?(bundle)
          bundle = bundle&.to_bundle

          if bundle_is_presidents_share_alone_in_pool?(bundle) &&
             @current_entity.num_shares_of(bundle.corporation) == 1
            percent = 10
            bundle = ShareBundle.new(bundle.shares, percent)
          end

          super(bundle)
        end

        private

        def bundle_is_presidents_share_alone_in_pool?(bundle)
          bundle&.owner == @game.share_pool &&
            bundle.presidents_share &&
            bundle.shares.size == 1 &&
            @game.share_pool.shares_of(bundle.corporation).size == 1
        end
      end
    end
  end
end
