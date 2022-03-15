#On définit les variables de notre container.

ARG tagImage=3.8.4-openjdk-8-slim
ARG imageInUse=maven

#On spcécifie l'image sur laquelle on ce référe.

FROM ${imageInUse}:${tagImage}

#On définit les variables de notre container.

ARG branch=""
ARG depoGit=""
ARG autheurGit=""
#On définit le maintener du container.

LABEL MAINTENER="Allan"

# On mets à jours notre images docker et install des packages dans notre container.

RUN apt-get update -y && \ 
    apt-get upgrade -y && \
    apt-get install -y git


# On récupére le code source depuis github

RUN git clone -b ${branch} https://github.com/$autheurGit/$depoGit.git

# On change notre répertoire de travail.

WORKDIR ${depoGit}

# On créer le jar de notre application.

RUN mvn clean package 

# Copie du jar à la racine du container pour qu'il soit visible par l'entrypoint.

RUN cp target/*.jar app.jar

# On retire les priviléges de l'utilisateur root.

RUN useradd user

RUN usermod -a -G user user

USER user:user

# On démarre l'application Spring à l'aide de java.

ENTRYPOINT ["java","-jar","app.jar"]
