CREATE OR REPLACE TRIGGER trg_ship_on_trip
BEFORE INSERT OR UPDATE ON Cargo_Manifest
FOR EACH ROW
DECLARE
    v_ship_on_trip INTEGER;
    ex_ship_on_trip EXCEPTION;
BEGIN
    SELECT COUNT(*) AS "Active Trips" INTO v_ship_on_trip
    FROM SHIP S INNER JOIN VEHICLE V ON S.VEHICLEID = V.ID
                INNER JOIN TRIP T ON S.MMSI = T.SHIPMMSI
                INNER JOIN CARGO_MANIFEST CM ON V.ID = CM.VEHICLEID
    WHERE S.MMSI = 211331613 AND SYSDATE BETWEEN T.INITIAL_DATE AND T.FINAL_DATE;

    IF v_ship_on_trip > 0 THEN
        RAISE ex_ship_on_trip;
    END IF;

    EXCEPTION
        WHEN ex_ship_on_trip THEN
            raise_application_error(-2000, 'Ship is on a trip');

END trg_ship_on_trip;