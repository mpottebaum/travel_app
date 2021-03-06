def my_reviews(user)
    system "clear"
    prompt = TTY::Prompt.new
    if user.reviews.length > 0
        resp = prompt.select("Here are #{user.name}'s reviews:", user.reviews.map{ |rev| rev.site.name } + ["Back"])
        if resp == "Back"
            return
        end
        rev = user.reviews.find {|review| review.site.name == resp }
        review_menu(rev, user)
        my_reviews(user)
    else
        prompt.select("#{user.name} has no reviews... yet!", ["Back"])
    end
end

def review_menu(rev, user)
    system "clear"
    prompt = TTY::Prompt.new
    puts "Site: #{rev.site.name}\nLocation: #{rev.site.destination.name}\nRating: #{rev.rating} - #{rev.content }\n\n"
    resp = prompt.select("Options", ["Delete", "Edit", "Back"])
    case resp
    when "Back"
        return
    when "Delete"
        user.delete_review(rev)
    when "Edit"
        system "clear"
        resp = prompt.select("Choose what to edit", ["Rating", "Content", "Back"])
        case resp
        when "Rating"
            rev.update(rating: prompt.slider("Choose new rating", min: 0, max: 10))
        when "Content"
            new_review = prompt.ask("Rewrite your review")
            resp = prompt.select("Are you sure?", ["Yes", "No"])
            if resp == "Yes"
                rev.update(content: new_review)
            else
                my_reviews(user)
            end
        end
        review_menu(rev, user)
    end
end