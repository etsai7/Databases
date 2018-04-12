delimiter $$
DROP PROCEDURE IF EXISTS ShowTickInfo $$
CREATE PROCEDURE ShowTickInfo(IN id VARCHAR(5))
    BEGIN 
        IF EXISTS (SELECT tick FROM Prices WHERE tick = id) THEN 
            SELECT * 
			FROM Prices JOIN Volume ON Prices.tick = Volume.tick AND Prices.date = Volume.date
				JOIN Misc ON Prices.tick = Misc.tick AND Prices.date = Misc.date
				JOIN AdjPrices ON Prices.tick = AdjPrices.tick AND Prices.date = AdjPrices.date 
        WHERE Prices.tick = id;
        ELSE 
            SELECT 'ERROR: Tick NOT FOUND' AS 'Result'; 
        END IF; 
    END$$
delimiter ;

delimiter $$
DROP PROCEDURE IF EXISTS FindTickerWithDate $$
CREATE procedure FindTickerWithDate(IN id VARCHAR(5), IN dt VARCHAR(10)) 
    BEGIN 
        IF EXISTS (SELECT tick FROM Prices WHERE tick = id) AND EXISTS (SELECT date FROM Prices WHERE dt = date) THEN 
            SELECT * 
            FROM Prices JOIN Volume ON Prices.tick = Volume.tick AND Prices.date = Volume.date
            JOIN Misc ON Prices.tick = Misc.tick AND Prices.date = Misc.date
            JOIN AdjPrices ON Prices.tick = AdjPrices.tick AND Prices.date = AdjPrices.date
            WHERE Prices.date = dt AND Prices.tick = id;
        ELSE
            SELECT 'ERROR: UPDATE FAILED INVALID Ticker OR Date' AS 'Result'; 
        END IF; 
    END$$
delimiter ;

delimiter $$
DROP PROCEDURE IF EXISTS FindTickerWithDateRange $$
CREATE procedure FindTickerWithDateRange(IN id VARCHAR(5), IN dt1 VARCHAR(10), IN dt2 VARCHAR(10)) 
    BEGIN 
        IF EXISTS (SELECT tick FROM Prices WHERE tick = id) THEN 
            SELECT * 
            FROM Prices JOIN Volume ON Prices.tick = Volume.tick AND Prices.date = Volume.date
            JOIN Misc ON Prices.tick = Misc.tick AND Prices.date = Misc.date
            JOIN AdjPrices ON Prices.tick = AdjPrices.tick AND Prices.date = AdjPrices.date
            WHERE (Prices.date >= dt1 AND Prices.date <= dt2) AND Prices.tick = id;
        ELSE
            SELECT 'ERROR: UPDATE FAILED INVALID Ticker OR Date' AS 'Result'; 
        END IF; 
    END$$
delimiter ;

delimiter $$
DROP PROCEDURE IF EXISTS GreaterClosePrice $$
CREATE procedure GreaterClosePrice(IN cPrice FLOAT) 
    BEGIN 
        IF EXISTS (SELECT close FROM Prices WHERE close >= cPrice) THEN 
            SELECT DISTINCT(Prices.tick)
            FROM Prices 
            WHERE Prices.close >= cPrice
            ORDER BY Prices.tick ASC;
        ELSE
            SELECT 'ERROR: UPDATE FAILED INVALID Closing Price' AS 'Result'; 
        END IF; 
    END$$
delimiter ;

delimiter $$
DROP PROCEDURE IF EXISTS LesserClosePrice $$
CREATE procedure LesserClosePrice(IN cPrice FLOAT) 
    BEGIN 
        IF EXISTS (SELECT close FROM Prices WHERE close <= cPrice) THEN 
            SELECT DISTINCT(Prices.tick)
            FROM Prices 
            WHERE Prices.close <= cPrice
            ORDER BY Prices.tick ASC;
        ELSE
            SELECT 'ERROR: UPDATE FAILED INVALID Closing Price' AS 'Result'; 
        END IF; 
    END$$
delimiter ;

delimiter $$
DROP PROCEDURE IF EXISTS GreaterOpeningPrice $$
CREATE procedure GreaterOpeningPrice(IN oPrice FLOAT) 
    BEGIN 
        IF EXISTS (SELECT open FROM Prices WHERE open >= oPrice) THEN 
            SELECT DISTINCT(Prices.tick)
            FROM Prices 
            WHERE Prices.open >= oPrice
            ORDER BY Prices.tick ASC;
        ELSE
            SELECT 'ERROR: UPDATE FAILED INVALID Opening Price' AS 'Result'; 
        END IF; 
    END$$
delimiter ;

delimiter $$
DROP PROCEDURE IF EXISTS LesserOpenPrice $$
CREATE procedure LesserOpenPrice(IN oPrice FLOAT) 
    BEGIN 
        IF EXISTS (SELECT open FROM Prices WHERE open <= oPrice) THEN 
            SELECT DISTINCT(Prices.tick)
            FROM Prices 
            WHERE Prices.open <= oPrice
            ORDER BY Prices.tick ASC;
        ELSE
            SELECT 'ERROR: UPDATE FAILED INVALID Opening Price' AS 'Result'; 
        END IF; 
    END$$
delimiter ;

delimiter $$
DROP PROCEDURE IF EXISTS PercentGrowth $$
CREATE procedure PercentGrowth(IN growth FLOAT) 
    BEGIN 
        IF EXISTS (SELECT tick FROM Prices) THEN 
            SELECT Prices.tick, Prices.date
            FROM Prices 
            WHERE Prices.close/Prices.open >= (1+growth)
            ORDER BY Prices.tick ASC;
        ELSE
            SELECT 'ERROR: UPDATE FAILED INVALID Opening Price' AS 'Result'; 
        END IF; 
    END$$
delimiter ;