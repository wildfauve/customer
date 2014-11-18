class EventsWorker
  include Sneakers::Worker
  # This worker will connect to "customer.event" queue
  # env is set to nil since by default the actuall queue name would be
  # "dashboard.posts_development"
  from_queue "customer.event", env: nil

  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  # which we can pass to RecentPosts service without
  # changes
  def work(raw_event)
    event = JSON.parse(raw_event)
    if event["event"] == "kiwi_identity"
      Party.id_reference(event)
      ack! # we need to let queue know that message was received
    else
      ack!
    end
  end
end

=begin

{
  "event":"account_creation",
  "timestamps": {
    "account_create_time":"2014-11-18T19:34:39.528+13:00"
  },
  "sales_product":{
    "_links":{
      "self":{
        "href":"http://localhost:3022/api/v1/sales_products/54642ace4d6174b2be010000"
      }
    }
  },
  "transaction_account":{
    "type":"Cheque Account",
    "_links":{
      "self":{
        "href":"http://localhost:3023/api/v1/accounts/546ae87f4d6174982c000000"
      }
    }
  },
  "party":{
    "_links":{
      "self":{
        "href":"http://localhost:3021/api/v1/parties/545964134d6174bb8d050000"
      }
    }
  }
}

{
  "event"=>"kiwi_identity",
  "ref"=>[
    {
      "link"=>"http://localhost:3021/api/v1/parties/545964134d6174bb8d050000",
      "ref"=>"party"
    },
    {
      "ref"=>"sub",
      "id"=>"545963db4d61745aead30000"
    },
    {
      "link"=>"http://localhost:3020/kiwis/545964134d6174bc640a0000",
      "ref"=>"kiwi"
    }
  ],
  "id_token"=>{"sub"=>"545963db4d61745aead30000"}
}
=end