module Spree
  OrderContents.class_eval do

    def add(variant, quantity = 1, options = {}, babe_id)
      line_item = add_to_line_item(variant, quantity, options, babe_id)
      after_add_or_remove(line_item, options)
    end

    def add_to_line_item(variant, quantity, options = {}, babe_id)

      line_item = grab_line_item_by_variant(variant, false, options)

      if line_item
        line_item.quantity += quantity.to_i
        line_item.currency = currency unless currency.nil?
      else
        opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
                                                      permit(PermittedAttributes.line_item_attributes)
        line_item = order.line_items.new(quantity: quantity,
                                         variant: variant,
                                         options: opts,
                                         babe_id: babe_id)
      end
      line_item.target_shipment = options[:shipment] if options.has_key? :shipment
      line_item.save!
      line_item
    end




  end
end
