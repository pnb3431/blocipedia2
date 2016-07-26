module CollaboratorsHelper
    def list_collaborators(collaborators, wiki)
        if wiki.private?

        if wiki.collaborating_users.any?
            collaborators.map(&:username).join(', ') + " are collaborating."
        elsif wiki.id == current_user.id
            "No one is collaborating on this wiki. Add some collaborators below:"
        else
            "No one is collaborating on this wiki."
        end
      
        end
    end
end
