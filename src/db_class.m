classdef db_class
    
    properties
        conn;
    end
    
    methods
        function obj = db_class(host, user, pass, dbName)
        % Konstruktor 
        % Ulazni parametri:
        %        host : localhost
        %        user : vjerojatno root ili kako zadas
        %        pass : tvoja lozinka
        %        dbName : ime baze (ako koristis moju bazu onda strojno)
        % Koristenje:
        %        varijabla = db_class(parametri)
        
            javaaddpath('../static/mysql-connector-java-5.1.25/mysql-connector-java-5.1.25-bin.jar');
            jdbcString = sprintf('jdbc:mysql://%s/%s', host, dbName);
            jdbcDriver = 'com.mysql.jdbc.Driver';
            obj.conn = database(dbName, user , pass, jdbcDriver, jdbcString);
        end
        
        function query = db_query(obj,q)
        % Funkcija za dohvacanje podataka iz baze
        % Ulazni parametri
        %       q : sql upit oblika 'SELECT * FROM ....'
        % Vraca vektor ili matricu rezultata
        
            data = fetch(exec(obj.conn, q));
            query = data.Data;
        end
        
        function delete(obj)
        % Destruktor zatvara konekciju
        
            close(obj.conn)
        end
    end
    
end

