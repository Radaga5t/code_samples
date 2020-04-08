unless Services::Subscriptions::SubscriptionService.exists?
  Services::Subscriptions::SubscriptionService.create(
    name: '30 дней',
    description: '
      <ul>
        <li>Безлимитный отклик</li>
        <li>Безлимитные задания</li>
      </ul>
    ',
    duration: 30,
    price: Money.new(5_000, 'HUF')
  )

  Services::Subscriptions::SubscriptionService.create(
    name: '60 дней',
    description: '
      <ul>
        <li>Безлимитный отклик</li>
        <li>Безлимитные задания</li>
      </ul>
    ',
    duration: 60,
    price: Money.new(9_000, 'HUF')
  )

  Services::Subscriptions::SubscriptionService.create(
    name: '90 дней',
    description: '
      <ul>
        <li>Безлимитный отклик</li>
        <li>Безлимитные задания</li>
      </ul>
    ',
    duration: 90,
    price: Money.new(13_000, 'HUF')
  )
end

unless Services::SingleOffers::SingleOfferService.exists?
  Services::SingleOffers::SingleOfferService.create(
    name: 'Покупка услуги на сайте',
    price: Money.new(1_000, 'HUF')
  )
end
