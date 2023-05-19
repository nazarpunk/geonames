import mysql from "mysql2";

const con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "qwerty1Q",
    port: 3306,
    database: 'geo',
    multipleStatements: true,
});

let page = 1;

await con.promise().query(`
    drop table if exists np;
    create table np
    (
        Ref varchar(255) null,
        pnt POINT not null srid 0,
        Description varchar(255) null,
        DescriptionRu varchar(255) null,
        DescriptionTranslit varchar(255) null,
        Area varchar(255) null,
        AreaDescription varchar(255) null,
        AreaDescriptionRu varchar(255) null,
        AreaDescriptionTranslit varchar(255) null,
        spatial index (pnt)
    );
`);

const send = async () => {
    const request = await fetch("https://api.novaposhta.ua/v2.0/json/", {
        body: JSON.stringify({
            'apiKey': '30b1b0cbb9be4bc3172ec46df366f576',
            'modelName': 'Address',
            'calledMethod': 'getSettlements',
            'methodProperties': {
                'Page': page,
                'Warehouse': 0,
            }
        }),
        method: "POST",
    });

    const response = await request.json();

    const values = [];

    if (response.data.length === 0) {
        console.log(`end ${page}`);
        return;
    }

    const v = [];

    for (const d of response.data) {
        v.push(`(${[
            con.escape(d.Ref),
            `POINT(${d.Longitude},${d.Latitude})`,
            con.escape(d.Description),
            con.escape(d.DescriptionRu),
            con.escape(d.DescriptionTranslit),
            con.escape(d.Area),
            con.escape(d.AreaDescription),
            con.escape(d.AreaDescriptionRu),
            con.escape(d.AreaDescriptionTranslit)
        ].join(',')})`);
    }


    await con.promise().query(`
        insert into np (Ref,
                        pnt,
                        Description,
                        DescriptionRu,
                        DescriptionTranslit,
                        Area,
                        AreaDescription,
                        AreaDescriptionRu,
                        AreaDescriptionTranslit)
        values ${v.join(',')}
    `);

    console.log(page);

    page++;
    await send();
};

await send();


