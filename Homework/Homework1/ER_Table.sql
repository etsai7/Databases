CREATE TABLE Feedback
(
  FeedBack_ID INT NOT NULL,
  Feedback_Comments CHAR NOT NULL,
  Feedback_Rating INT NOT NULL,
  Date_Written DATE NOT NULL,
  Edits INT NOT NULL,
  Seller_or_Bidder CHAR NOT NULL,
  PRIMARY KEY (FeedBack_ID)
);

CREATE TABLE Auction_Types
(
  Auction_Type CHAR NOT NULL,
  No._of_Items_bc_of_Type INT NOT NULL,
  PRIMARY KEY (Auction_Type)
);

CREATE TABLE Auctions
(
  AuctionID INT NOT NULL,
  Start_Date DATE NOT NULL,
  End_Date DATE NOT NULL,
  Current_bidder CHAR NOT NULL,
  Winning_bidder CHAR NOT NULL,
  Bidders INT NOT NULL,
  Winning_Bid FLOAT NOT NULL,
  Hard_End_Date DATE NOT NULL,
  Auction_Status CHAR NOT NULL,
  Subtype CHAR NOT NULL,
  Auction_Type CHAR NOT NULL,
  PRIMARY KEY (AuctionID),
  FOREIGN KEY (Auction_Type) REFERENCES Auction_Types(Auction_Type)
);

CREATE TABLE Items
(
  Starting_Price FLOAT NOT NULL,
  Description CHAR NOT NULL,
  ItemID INT NOT NULL,
  List_Date DATE NOT NULL,
  Item_Name CHAR NOT NULL,
  Current_Price FLOAT NOT NULL,
  Closing_Price FLOAT NOT NULL,
  Availability_Status CHAR NOT NULL,
  Relist_date DATE NOT NULL,
  Sold_Date DATE NOT NULL,
  Item_Type CHAR NOT NULL,
  Minimum_Price FLOAT NOT NULL,
  Instant_Buy_Price FLOAT NOT NULL,
  AuctionID INT NOT NULL,
  Auction_Type CHAR NOT NULL,
  PRIMARY KEY (ItemID),
  FOREIGN KEY (AuctionID) REFERENCES Auctions(AuctionID),
  FOREIGN KEY (Auction_Type) REFERENCES Auction_Types(Auction_Type)
);

CREATE TABLE Item_FeedBack
(
  Feedback INT NOT NULL,
  Q&A CHAR NOT NULL,
  Comments CHAR NOT NULL,
  Score INT NOT NULL,
  ItemID INT NOT NULL,
  PRIMARY KEY (Score),
  FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);

CREATE TABLE Item_Shipping
(
  Expedited DATE NOT NULL,
  Normal DATE NOT NULL,
  Delay DATE NOT NULL,
  ItemID INT NOT NULL,
  FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);

CREATE TABLE Item_Payment
(
  PayPal INT NOT NULL,
  Credit_Card INT NOT NULL,
  Gift_Card INT NOT NULL,
  ItemID INT NOT NULL,
  FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);

CREATE TABLE User
(
  UserID INT NOT NULL,
  First_Name CHAR NOT NULL,
  Last_Name CHAR NOT NULL,
  User_Type CHAR NOT NULL,
  Overall_Ranking INT NOT NULL,
  Bank_Acct_No. INT NOT NULL,
  Points_till_next_Rank INT NOT NULL,
  Ranking_Benefits CHAR NOT NULL,
  AuctionID INT NOT NULL,
  FeedBack_Given_ID INT NOT NULL,
  PRIMARY KEY (UserID),
  FOREIGN KEY (AuctionID) REFERENCES Auctions(AuctionID),
  FOREIGN KEY (FeedBack_Given_ID) REFERENCES Feedback(FeedBack_ID)
);

CREATE TABLE User_Information
(
  Join_Date DATE NOT NULL,
  Address CHAR NOT NULL,
  City CHAR NOT NULL,
  State CHAR NOT NULL,
  Country CHAR NOT NULL,
  Phone_Number INT NOT NULL,
  Termination_Date DATE NOT NULL,
  UserID INT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE Bid_List
(
  Bid_Amount INT NOT NULL,
  Proxy_Bid_Amount INT NOT NULL,
  Bid_Date DATE NOT NULL,
  Bid_Retraction_Date DATE NOT NULL,
  UserID INT NOT NULL,
  ItemID INT NOT NULL,
  AuctionID INT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES User(UserID),
  FOREIGN KEY (ItemID) REFERENCES Items(ItemID),
  FOREIGN KEY (AuctionID) REFERENCES Auctions(AuctionID)
);

CREATE TABLE Watch_List
(
  Max_Bid_Price INT NOT NULL,
  UserID INT NOT NULL,
  ItemID INT NOT NULL,
  AuctionID INT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES User(UserID),
  FOREIGN KEY (ItemID) REFERENCES Items(ItemID),
  FOREIGN KEY (AuctionID) REFERENCES Auctions(AuctionID)
);

CREATE TABLE Sell_List
(
  UserID INT NOT NULL,
  ItemID INT NOT NULL,
  AuctionID INT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES User(UserID),
  FOREIGN KEY (ItemID) REFERENCES Items(ItemID),
  FOREIGN KEY (AuctionID) REFERENCES Auctions(AuctionID)
);

CREATE TABLE Bidders_List
(
  Bid_Amount INT NOT NULL,
  Bid_Time DATE NOT NULL,
  AuctionID INT NOT NULL,
  UserID INT NOT NULL,
  FOREIGN KEY (AuctionID) REFERENCES Auctions(AuctionID),
  FOREIGN KEY (UserID) REFERENCES User(UserID)
);