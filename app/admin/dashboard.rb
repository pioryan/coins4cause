ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end


    columns do
       column do
         panel "Recent Transactions" do
           ul do
             if current_user.is_admin?
              transactions = Transaction.limit(5)
             else
               transactions = current_user.transactions.limit(5)
             end
             transactions.map do |transaction|
               if transaction.type
                 li link_to("Withdrawal for #{transaction.user.nickname} amounting to #{transaction.amount} BTC Cents, Completed: #{transaction.created_at.strftime("%m/%d/%Y %I:%M%p") }", admin_transaction_path(transaction))
               else
                 li link_to("Donation for #{transaction.user.nickname} amounting to #{transaction.amount} BTC Cents, Received: #{transaction.created_at.strftime("%m/%d/%Y %I:%M%p") }", admin_transaction_path(transaction))
               end
             end
           end
         end
       end

       column do
         if current_user.is_admin?
           transactions = Transaction.all
         else
           transactions = current_user.transactions
         end
         panel "Info" do
           para "Welcome to ActiveAdmin."
           para "Total Donations: #{transactions.sum(:amount)} BTC Cents."
         end
       end
    end
  end # content
end
