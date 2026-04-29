-- Create a table definition for the Snow_survey table that is maximally expressive, that is, that captures as much of the semantics and characteristics of the data using SQL’s data definition language as is possible.

CREATE TABLE Survey (
    site VARCHAR(4) NOT NULL,
    year INTEGER NOT NULL CHECK (year BETWEEN 2000 AND 2100),
    date DATE NOT NULL,
    plot VARCHAR,
    location VARCHAR,

    snow_cover NUMERIC CHECK (snow_cover BETWEEN 0 AND 100),
    water_cover NUMERIC CHECK (water_cover BETWEEN 0 AND 100),
    land_cover NUMERIC CHECK (land_cover BETWEEN 0 AND 100),
    total_cover NUMERIC CHECK (total_cover BETWEEN 0 AND 100),
        CHECK (total_cover = 100),

    observer VARCHAR,
    notes TEXT,

    PRIMARY KEY (site, date, plot, location, observer),

    --foreign keys--
    CONSTRAINT fk_site
        FOREIGN KEY (site) REFERENCES Site(code)
    CONSTRAINT fk_personnel
        FOREIGN KEY (observer) REFERENCES Personnel(abbreviation)
)