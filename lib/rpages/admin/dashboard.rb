if defined?(ActiveAdmin)
    ActiveAdmin.register_page "Dashboard" do

      menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

        content title: "Dashboard" do
            # panel "Content" do
                
            # end

            panel "Admin Area" do
                columns do
                    attributes_table_for "Pages" do
                        row "Pages (all)" do
                            Page.count
                        end
                        row "Pages (active)" do
                            Page.active.count
                        end
                        row "Primary Page" do
                            if Page.primary.present?
                                link_to(Page.primary.first.name, [:admin, Page.primary.first])
                            else
                                "- no primary page yet -"
                            end
                        end
                    end

                    attributes_table_for "Other" do
                        row "Content Blocks" do
                            ContentBlock.count
                        end
                        row "Setts" do
                            Sett.count
                        end
                        row "Primary Setts" do
                            Sett.primary.count
                        end
                        row "Sett Objects" do
                            SettObject.count
                        end
                    end
                end

                columns do
                    attributes_table_for "Users" do
                        row "Users (Num)" do
                            User.count
                        end
                        row "Last online" do
                            User.order("updated_at Desc").first.name
                        end
                        row "Number of Admins" do
                            User.where(admin: true).count
                        end
                        row "Number of non Admins" do
                            User.where(admin: false).count
                        end
                    end
                end
            end
        end
    end
end
