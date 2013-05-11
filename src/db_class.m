classdef db_class
    
    properties
        conn;
    end
    
    methods
        % Konstruktor 
        % Ulazni parametri:
        %        host : localhost
        %        user : vjerojatno root ili kako zadas
        %        pass : tvoja lozinka
        %        dbName : ime baze (ako koristis moju bazu onda strojno)
        % Koristenje:
        %        varijabla = db_class(parametri)
        function obj = db_class(host, user, pass, dbName)
            javaaddpath('../static/mysql-connector-java-5.1.25/mysql-connector-java-5.1.25-bin.jar');
            jdbcString = sprintf('jdbc:mysql://%s/%s', host, dbName);
            jdbcDriver = 'com.mysql.jdbc.Driver';
            obj.conn = database(dbName, user , pass, jdbcDriver, jdbcString);
        end
        
        % Funkcija za dohvacanje podataka iz baze
        % Ulazni parametri
        %       q : sql upit oblika 'SELECT * FROM ....'
        % Vraca vektor ili matricu rezultata
        function query = db_query(obj,q)
            data = fetch(exec(obj.conn, q));
            query = data.Data;
        end
        
        % Destruktor zatvara konekciju
        function delete(obj)
            close(obj.conn)
        end
    end
    
end

