require 'rufus-scheduler'
require 'net/http'
require 'fcm'
s = Rufus::Scheduler.singleton

fcm_client = FCM.new("AAAAUpQ3OsQ:APA91bFgIYjUqP2BzaVmppgvhKlFlX0jK4gmDrDvCp__drk8ZlRdlm10BZVXkHuu_pbWtk8i0mCiU8QDkCB9ps3VQo92OX8m8AomZDHgyqJpSc_KHoWCZdhhzP6KDvcr_njjZlWt73Xd")


s.every '25m' do
    #do every 5 seconds exec this code
    @list_items = ListItem.all
    @users = User.all

    @list_items.each {  |list_item| 
        begin
            
            list_item.requests = list_item.requests + 1 

            url = URI.parse(list_item.url_endpoint)
            req = Net::HTTP::Get.new(url.to_s)
            res = Net::HTTP.start(url.host, url.port) {|http|
                http.request(req)
            }
            if res.body == '{"status": "ok"}'
                list_item.status = 'ok'
                
            else
                list_item.status = 'ko'
                list_item.thrown_errors = list_item.thrown_errors + 1
            end
        rescue StandardError
            list_item.status = 'ko'
            list_item.thrown_errors = list_item.thrown_errors + 1
        end

        if list_item.status == 'ok'
            @users.each { | user |  
            
                options = { "notification": {
                            "title": "Server " + list_item.name + "down !",
                            "body": list_item.name + " down..."
                        }
                }
                ids = []
                ids.push(user.fcm_token)
                response = fcm_client.send(ids, options)
                puts 'sent! to ' + user.email
            } 
        end

        list_item.save!
    }

end
