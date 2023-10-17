## Transfer Money Api
Ruby-on-Rails application with ActiveRecord, Dry-rb, RSpec
### Dependencies:
- Ruby 3.2.2
- PostgreSQL
- Redis

### Description
The application disburse orders to merchants as a scheduled task. 
Merchants can specify disbursement days with the options once a week or daily.
Once a day the application defines relevant merchants in regards disbursement days and 
crates disbursements with the amount and deducted fees, base on relevant orders.

import of merchants and orders is done from scv files, that at the moment are kept in the application.

### Installation:
- Clone poject
- Run bundler:

 ```shell
 $ bundle install
 ```
- Copy database.yml:
```shell
$ cp config/database.yml.sample config/database.yml
```

- Create and migrate database:

```shell
 $ bundle exec rails db:create
 $ bundle exec rails db:migrate
```
- Run application:

 ```shell
 $ rails server
 ```
- Run sidekiq:
 ```shell
 $ sidekiq
 ```

- Migrate data from csv files:
 ```shell
 $ rake csv_merchant_data:import
 ```

- Disburse migrated orders retrospectively:
 ```shell
 $ rake merchants:disburse_retrospectively
 ```

##### Tests:
To execute automation tests, run following commands:

```shell
 $ bundle exec rails db:migrate RAILS_ENV=test #(the first time only)
 $ bundle exec rspec
```

### Explanation of the approach:
Service Oriented Architecture (SOA) modular design with step-based operations. 
For Rails application I follow the idea that models inherit ActiveRecord, which means they have to conform 
ORM pattern only and should not contain any other business logic aside from Object Oriented Mapping(recording).
That's why models contain only associations and record validations.
With that I prefer to keep models as stupid as possible, which means: no callbacks in models. 
All the business logic should reside in services only, which allow us to keep following to the main OOP principals such SOLID etc.

#### NOTES:
- Since one of the requirements was to provide the table with statistics separated by years,
I decided to migrate the orders with their `created_at` and include to disbursements the field (column) `perform_datetime`.
Which allowed to implement the payout system for the subsequently imported orders in such a way that system
is able to accept the `perform_datetime` as an argument and pay out the corresponding orders.
- All over the application all the time-kind columns have the `datetime` type for the flexibility.
- Relation between `disbursement` and `merchant_orders` is `has many/one trough` for the flexibility and scalability reasons.
- While calculating monthly fees it checks for existing disbursement in the relevant month with nonzero monthly fee.
- Services for parsing scv and retrospective disbursement such as `Disbursements::CreateRetrospectivelyService` 
seem to be like one-time-use and may need to be archived, for now they are kept for demo.
#### STATS:
###### Please note that the **Year** column refers to `Disbursements#perform_datetime`, if `perform_datetime` is in the beginning of 2023, the disbursement may contain orders created in the end of 2022
|    Year     |  Number of disbursements  | Amount disbursed to merchants | Amount of order fees | Number of monthly fees charged | Amount of monthly fee charged |
|:-----------:|:-------------------------:|:-----------------------------:|:--------------------:|:------------------------------:|:-----------------------------:|
|    2022     |           1435            |         15916530.48 €         |     136484.21 €      |              111               |           1845.42 €           |
|    2023     |           1056            |         18117463.13 €         |     155351.17 €      |              85                |           1697.43 €           |
### License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
