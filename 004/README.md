## Zipcode: 90210

## Installing

There is a .rvmrc included.

This works with ruby 1.8.7 or 1.9.3

Standard bundler:

    bundle install

## Testing

Run rake:

    rake

## Usage

Run bacon.rb with input and output file arguments:

  bundle exec ./bacon.rb sample_input.txt sample_output.txt

## Flog

Run flog directly:

    flog *.rb lib/*.rb

Or use rake:

    rake flog

Flog output:

   174.8: flog total
     4.6: flog/method average

    10.8: Network#iterate_connections      lib/network.rb:56
    10.3: Network#output                   lib/network.rb:64
    10.2: Network#build                    lib/network.rb:17
     9.8: User#iterate_outputs             lib/user.rb:23
     8.8: Network#order_results_by_mentions lib/network.rb:27
     8.7: Network#build_recurse            lib/network.rb:50
     7.9: main#none
     7.7: Runner::run                      bacon.rb:11
     7.6: Network#process_result           lib/network.rb:37
     7.0: Network#connect_ordered_mentions lib/network.rb:44
     6.2: Runner::carousel                 bacon.rb:19
     5.9: Degrees#build_connection_if_mentioned_back lib/degrees.rb:69
     5.9: Degrees#process_tweet_line_for   lib/degrees.rb:31 

