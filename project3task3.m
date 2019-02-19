
ind4 = find(cell2mat(T1.Product_Category)=='C'); % index for all entries where the product is category C

C_customers = unique(T1.Customer_ID(ind4,:),'stable'); % all customers who bought a product of category C

ind5 = find(ismember(T1.Customer_ID, C_customers)); % index array of all these customers' purchases in the full table

avg_spends = grpstats(T1(ind4,:),'Customer_ID','mean','DataVars',{'Product_Value'}); % average product values per order in category C, grouped by customer

avg_ratings = grpstats(T1(ind5,:),'Customer_ID','mean','DataVars',{'Rating'}); % average ratings given, grouped by customer



scaled_avg_spends = (4*(avg_spends{:,3}./max(avg_spends{:,3}))) + 1; % scales the average spends down to values between 1 and 5

Ranking = mean([scaled_avg_spends,avg_ratings{:,3}],2); % a ranking system based on the mean of the scaled avergae spend, and the average rating
ranked_customers = sortrows(table(C_customers,Ranking), 2, 'descend'); % sorts the customers is descending order according to the ranking system just defined

recipients = ranked_customers{1:100,1} % returns the top 100 customers according to the ranking