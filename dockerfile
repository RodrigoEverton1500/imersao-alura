FROM python:3.11-slim

# Install required system deps: gcc, rust, etc.
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    rustc \
    cargo \
    && rm -rf /var/lib/apt/lists/*

#define o diretorio de trabalho dentro do container
WORKDIR /app

#copia o arquivo de requisitos e instala as dependencias
#usamos o no cache parar evitar o cache do pip, reduzindo o tamanho da imagem
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

#copia o restante do codigo da aplicacao para o diretorio de trabalho
COPY . .

#expoe a porta que a plicacao FastAPI ira rodar
EXPOSE 8000

#comando para rodar aplicacao usando uvicorn
#o host 0.0.0.0 permite que a aplicacao seja acessivel externamente ao container
CMD [ "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload" ]