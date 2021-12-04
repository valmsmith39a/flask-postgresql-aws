FROM python:3.8-slim

# prevents running sudo commands
RUN useradd -r -s /bin/bash cheeze

# set current env
ENV HOME /app
WORKDIR /app
ENV PATH="/app/.local/bin:${PATH}"

RUN chown -R cheeze:cheeze /app
USER cheeze

ENV FLASK_ENV=production

# set argument vars in docker-run command
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

ARG FLASK_SECRET_KEY

ENV AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY  
ENV AWS_DEFAULT_REGION $AWS_DEFAULT_REGION 
ENV FLASK_SECRET_KEY $FLASK_SECRET_KEY  

# avoid cache purge by adding requirements first
ADD ./requirements.txt ./requirements.txt

RUN pip install --no-cache-dir -r ./requirements.txt --user

# add the rest of the files
COPY . /app
WORKDIR /app

# start the server
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app", "--workers=5"]

