-- 1. Display every USERNAME and the lowest RATING they have left in a review.
SELECT
    u.UserName,
    MIN(r.Rating) AS LowestRating
FROM UserBase u
JOIN Reviews r ON u.UserID = r.UserID
GROUP BY u.UserName
ORDER BY u.UserName;

-- 2. Display every user's EMAIL and the REVIEWTEXT they left.
SELECT 
    u.Email,
    r.Review
FROM UserBase u
JOIN Reviews r 
    ON u.UserID = r.UserID
ORDER BY u.Email;

-- 3. Display the FIRSTNAME, EMAIL, and WALLETFUNDS of every user that does not have a WISHLIST.
SELECT
    u.FirstName,
    u.Email,
    u.WalletFunds
FROM UserBase u
LEFT JOIN WishList w
    ON u.UserID = w.UserID
WHERE w.UserID IS NULL;


-- 4. Display every USERNAME and number of products they have ordered.
SELECT
    u.UserName,
    COUNT(o.ProductCode) AS NumberOfProductsOrdered
FROM UserBase u
LEFT JOIN Orders o
    ON u.UserID = o.UserID
GROUP BY u.UserName
ORDER BY u.UserName;

-- 5. Display the age of any user who has ordered a product within the last 6 months.
SELECT
    u.UserName,
    FLOOR(MONTHS_BETWEEN(SYSDATE, u.Birthday) / 12) AS Age
FROM UserBase u
JOIN Orders o
    ON u.UserID = o.UserID
WHERE o.PurchaseDate >= ADD_MONTHS(SYSDATE, -6)
GROUP BY u.UserName, u.Birthday
ORDER BY u.UserName;

-- 6. Display the USERNAME and BIRTHDAY of the user who has the highest friend count.
SELECT
    u.UserName,
    u.Birthday
FROM UserBase u
JOIN (
    SELECT
        UserID,
        COUNT(FriendID) AS FriendCount
    FROM FriendsList
    GROUP BY UserID
    ORDER BY FriendCount DESC
) f
    ON u.UserID = f.UserID
WHERE ROWNUM = 1;

-- 7. Display the PRODUCTNAME, RELEASEDATE, PRICE, and DESCRIPTION for any product found in the WISHLIST table.
SELECT
    p.ProductName,
    p.ReleaseDate,
    p.Price,
    p.Description
FROM ProductList p
JOIN WishList w
    ON p.ProductCode = w.ProductCode
ORDER BY p.ProductName;

-- 8. Display the PRODUCTNAME, highest RATING, and number of reviews for each product in the REVIEWS table.
--    Order the results in descending order of the RATING.
SELECT
    p.ProductName,
    MAX(r.Rating) AS HighestRating,
    COUNT(r.Rating) AS NumberOfReviews
FROM ProductList p
JOIN Reviews r
    ON p.ProductCode = r.ProductCode
GROUP BY p.ProductName
ORDER BY HighestRating DESC;

-- 9. Create a view that displays the PRODUCTNAME, GENRE, and RATING for every product
--    with a 5 or a 1 RATING. Order the results in ascending order of the RATING.

CREATE OR REPLACE VIEW ProductRatingView AS
SELECT
    p.ProductName,
    p.Genre,
    r.Rating
FROM ProductList p
JOIN Reviews r
    ON p.ProductCode = r.ProductCode
WHERE r.Rating IN (1, 5)
ORDER BY r.Rating ASC;

-- 10. Display the count of products ordered, grouped by GENRE.
--     Order the results in alphabetical order of GENRE.

SELECT
    p.Genre,
    COUNT(o.ProductCode) AS NumberOfProductsOrdered
FROM Orders o
JOIN ProductList p
    ON o.ProductCode = p.ProductCode
GROUP BY p.Genre
ORDER BY p.Genre ASC;

-- 11. Create a view that displays each PUBLISHER, the average PRICE,
--     and the sum of HOURSPLAYED for their products.

CREATE OR REPLACE VIEW PublisherStatsView AS
SELECT
    p.Publisher,
    AVG(p.Price) AS AveragePrice,
    SUM(u.HoursPlayed) AS TotalHoursPlayed
FROM ProductList p
JOIN UserLibrary u
    ON p.ProductCode = u.ProductCode
GROUP BY p.Publisher
ORDER BY p.Publisher;

-- 12. Display the sum of money spent on products and their corresponding PUBLISHER,
--     from the ORDERS table. Order the results in descending order of the sum of money spent.

SELECT
    p.Publisher,
    SUM(p.Price) AS TotalMoneySpent
FROM Orders o
JOIN ProductList p
    ON o.ProductCode = p.ProductCode
GROUP BY p.Publisher
ORDER BY TotalMoneySpent DESC;

-- 13. Display the TICKETID, USERNAME, EMAIL, and ISSUE only for tickets
--     with a STATUS of 'NEW' or 'IN PROGRESS', sorted by the latest DATEUPDATED.

SELECT
    s.TicketID,
    u.UserName,
    s.Email,
    s.Issue
FROM UserSupport s
LEFT JOIN UserBase u
    ON s.Email = u.Email
WHERE s.Status IN ('NEW', 'IN PROGRESS')
ORDER BY s.DateUpdated DESC;

-- 14. Display the USERNAME and count of TICKETID that users have submitted for user support.
SELECT
    u.UserName,
    COUNT(s.TicketID) AS NumberOfTickets
FROM UserBase u
LEFT JOIN UserSupport s
    ON u.Email = s.Email
GROUP BY u.UserName
ORDER BY u.UserName;

-- 15. Display the USERID and EMAIL of any user who has submitted a support ticket
--     that used their FIRSTNAME, LASTNAME, or combination of the two in their EMAIL address.

SELECT
    u.UserID,
    u.Email
FROM UserBase u
JOIN UserSupport s
    ON u.Email = s.Email
WHERE LOWER(u.Email) LIKE LOWER('%' || u.FirstName || '%')
   OR LOWER(u.Email) LIKE LOWER('%' || u.LastName || '%')
   OR LOWER(u.Email) LIKE LOWER('%' || u.FirstName || u.LastName || '%');

-- 16. Display the EMAIL address of any user who has a 'NEW' or 'IN PROGRESS'
--     support ticket STATUS, where the EMAIL is not currently saved in the USERBASE table.

SELECT
    s.Email
FROM UserSupport s
LEFT JOIN UserBase u
    ON s.Email = u.Email
WHERE s.Status IN ('NEW', 'IN PROGRESS')
  AND u.Email IS NULL;

-- 17. Display the TICKETID, FIRSTNAME, LASTNAME, and USERNAME of any user
--     whose USERNAME is mentioned in the ISSUE of a support ticket.

SELECT
    s.TicketID,
    u.FirstName,
    u.LastName,
    u.UserName
FROM UserSupport s
JOIN UserBase u
    ON s.Email = u.Email
WHERE LOWER(s.Issue) LIKE LOWER('%' || u.UserName || '%');

-- 18. Display the USERNAME and PASSWORD associated with the EMAIL address provided in the support tickets.
SELECT
    u.UserName,
    u.Password
FROM UserBase u
JOIN UserSupport s
    ON u.Email = s.Email
ORDER BY u.UserName;

-- 19. Create a view for users with infractions assigned within the last month and non-null penalties.
CREATE OR REPLACE VIEW RecentPenaltiesView AS
SELECT
    u.UserName,
    i.DateAssigned,
    i.Penalty
FROM Infractions i
JOIN UserBase u
    ON i.UserID = u.UserID
WHERE i.Penalty IS NOT NULL
  AND i.DateAssigned >= ADD_MONTHS(SYSDATE, -1)
ORDER BY i.DateAssigned;

-- 20. Display users age 18+ with no infractions in the last 4 months.
SELECT
    u.UserName,
    u.Email
FROM UserBase u
LEFT JOIN Infractions i
    ON u.UserID = i.UserID
    AND i.DateAssigned >= ADD_MONTHS(SYSDATE, -4)
WHERE FLOOR(MONTHS_BETWEEN(SYSDATE, u.Birthday) / 12) >= 18
  AND i.UserID IS NULL
ORDER BY u.UserName;

-- 21. Display username, date assigned, and full guideline name for rule violations.
SELECT
    u.UserName,
    i.DateAssigned,
    i.RuleNum || ' ' || r.Title AS FullGuidelineName
FROM Infractions i
JOIN UserBase u
    ON i.UserID = u.UserID
JOIN CommunityRules r
    ON i.RuleNum = r.RuleNum
ORDER BY u.UserName, i.DateAssigned;

-- 22. Display user info and total severity points.
SELECT
    u.UserID,
    u.UserName,
    u.Email,
    SUM(i.SeverityPoints) AS TotalSeverityPoints
FROM UserBase u
LEFT JOIN Infractions i
    ON u.UserID = i.UserID
GROUP BY u.UserID, u.UserName, u.Email
ORDER BY TotalSeverityPoints DESC;

-- 23. Display title, description, and penalty for all assigned infractions.
SELECT
    r.Title,
    r.Description,
    i.Penalty
FROM Infractions i
JOIN CommunityRules r
    ON i.RuleNum = r.RuleNum
ORDER BY r.Title;

-- 24. Display users with at least 15 infractions.
SELECT
    u.UserName,
    COUNT(i.InfractionID) AS InfractionCount
FROM UserBase u
JOIN Infractions i
    ON u.UserID = i.UserID
GROUP BY u.UserName
HAVING COUNT(i.InfractionID) >= 15
ORDER BY InfractionCount DESC;






