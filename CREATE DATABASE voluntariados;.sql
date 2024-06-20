CREATE DATABASE voluntariados;

CREATE TABLE Usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) CHECK (tipo IN ('voluntario', 'organizacao')),
    telefone VARCHAR(15)
);

CREATE TABLE Oportunidade (
    id_oportunidade SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descricao TEXT NOT NULL,
    requisitos TEXT,
    data DATE NOT NULL,
    local VARCHAR(100),
    id_organizador INT,
    FOREIGN KEY (id_organizador) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Evento (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descricao TEXT NOT NULL,
    data DATE NOT NULL,
    local VARCHAR(100),
    id_organizador INT,
    FOREIGN KEY (id_organizador) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Inscricao (
    id_inscricao SERIAL PRIMARY KEY,
    id_voluntario INT,
    id_oportunidade INT,
    data_inscricao DATE NOT NULL,
    FOREIGN KEY (id_voluntario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_oportunidade) REFERENCES Oportunidade(id_oportunidade)
);

CREATE TABLE Participacao (
    id_participacao SERIAL PRIMARY KEY,
    id_voluntario INT,
    id_evento INT,
    data_participacao DATE NOT NULL,
    feedback TEXT,
    FOREIGN KEY (id_voluntario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_evento) REFERENCES Evento(id_evento)
);

INSERT INTO Usuario (nome, email, senha, tipo, telefone) 
VALUES ('João Silva', 'joao@example.com', 'senha123', 'voluntario', '123456789');

INSERT INTO Oportunidade (titulo, descricao, requisitos, data, local, id_organizador)
VALUES ('Ajudar na Cozinha Comunitária', 'Ajudar a preparar refeições para pessoas em situação de rua', 'Saber cozinhar', '2024-07-01', 'Rua das Flores, 123', 1);

INSERT INTO Inscricao (id_voluntario, id_oportunidade, data_inscricao)
VALUES (2, 1, '2024-06-20');

INSERT INTO Evento (titulo, descricao, data, local, id_organizador)
VALUES ('Feira de Saúde', 'Evento para promover saúde e bem-estar', '2024-07-15', 'Parque Central', 1);

INSERT INTO Participacao (id_voluntario, id_evento, data_participacao, feedback)
VALUES (2, 1, '2024-07-15', 'Foi uma experiência muito gratificante');

SELECT email 
FROM Usuario 
WHERE tipo = 'voluntario' 
AND id_usuario IN (
    SELECT id_voluntario 
    FROM Inscricao 
    WHERE id_oportunidade IN (
        SELECT id_oportunidade 
        FROM Oportunidade 
        WHERE data > CURRENT_DATE
    )
);

SELECT U.nome, E.titulo, P.data_participacao, P.feedback
FROM Participacao P
JOIN Usuario U ON P.id_voluntario = U.id_usuario
JOIN Evento E ON P.id_evento = E.id_evento
WHERE U.id_usuario = 2;


