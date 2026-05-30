import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, Genre } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepo: Repository<User>,
  ) {}

  findByPhone(phone: string): Promise<User | null> {
    return this.usersRepo.findOne({ where: { phone } });
  }

  findById(id: string): Promise<User | null> {
    return this.usersRepo.findOne({ where: { id } });
  }

  createFromPhone(phone: string): Promise<User> {
    const user = this.usersRepo.create({ phone });
    return this.usersRepo.save(user);
  }

  async updateGuestProfile(
    userId: string,
    pseudo: string,
    age: number,
    genre: Genre,
  ): Promise<User> {
    return this.usersRepo.manager.transaction(async (em) => {
      const existing = await em.findOne(User, { where: { pseudo } });
      if (existing && existing.id !== userId) {
        throw new ConflictException('Ce pseudo est indisponible.');
      }
      await em.update(User, userId, { pseudo, age, genre, isProfileComplete: true });
      const updated = await em.findOne(User, { where: { id: userId } });
      if (!updated) throw new NotFoundException('Utilisateur introuvable.');
      return updated;
    });
  }
}
